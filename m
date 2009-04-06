Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbZDFMhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbZDFMhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 08:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZDFMhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 08:37:24 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48791 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbZDFMhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 08:37:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=IMM8W8DsjrzkFpJr0rYfv6MiFS5DZnKRPijlv89EEP8GTQUPsnXy44ytqFRgPT7B/Y
         hx0k85qLWp1ntZPrGAhW6nVRrUUbZu/Y+OWWEZu2naKAWCKXfl/67PGZhGageZWo49DB
         iwGWOfdNNPq9gSjhFQvncdoTlAv29ARv7GDOg=
MIME-Version: 1.0
Date: Mon, 6 Apr 2009 14:37:21 +0200
Message-ID: <145d4e1a0904060537x358340c8n6b00bdc3d595c5b4@mail.gmail.com>
Subject: Missing CONFIG_IP_ROUTE_FWMARK flag in .config file
From: =?ISO-8859-1?Q?Javier_G=E1lvez_Guerrero?= 
	<javier.galvez.guerrero@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm not subscribed to the mailing list because following the
instructions of the LKML FAQ, I considered that, given I only want to
have a simple question answered, it isn't worth to subscribe to the
list. I would also like to apologize if this is not the better place
to post my question, but I think it really is. However, I searched for
an answer on the archive but I found nothing.

That said, I need to manage marked packets from different network
interfaces and I thought it was proper to use the MARK target of
iptables. I read that I need to have enabled CONFIG_IP_ROUTE_FWMARK=y
in the Kernel configuration but I can't find this parameter neither in
2.6.27-11 or 2.6.29 kernel, so my questions are:

Is this option still being supported (i.e. can I still mark packets in
Linux?)? Has this option been replaced with other/s? In this case, how
can the MARK support be enabled (I'm using the default kernel
configuration of Ubuntu 8.10 and MARK doesn't work properly)?


Once again, sorry if this is not the place to post my question, but I
didn't find a better one. Any help will be much appreciated. If you
consider to answer this mail, please, consider I'm not subscribed to
the ML, so add me to the CCs.


Thanks a lot and best regards,
Javi
