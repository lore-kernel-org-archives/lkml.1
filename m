Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbYAaBgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbYAaBgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 20:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbYAaBgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 20:36:06 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:14281 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbYAaBgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 20:36:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=u1vWWjzvb/mivz+DLbJCw7wi4MHmFzpoo1G/0UGBbqD9zVsszh9qI2cghkId+ortPKKm6F5jzZrHBgsLR+pcMHqW/4Zj2FZpNK0GbaF5c3li88FWSRMxfVnue+NBhzz079uwIwDsYSA/4Gz7ZkY9rvzuhYhqj8juSGbLJgQCjpc=
Message-ID: <faf3083f0801301736t10b6d251rb86b692dcf496868@mail.gmail.com>
Date: Wed, 30 Jan 2008 23:36:00 -0200
From: "Geraldo Netto" <geraldonetto@gmail.com>
To: linux-kernel@vger.kernel.org,
       "Flavio Alberto Lopes Soares" <flaviothunder@terra.com.br>
Subject: how to find out which modules are embedded and running in a static kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

Sorry for this newbie question,
but i would like to know how to find
out which modules are embedded
and running in a static kernel
because we have a kernel which
we don't know what components(drivers, ...)
are embedded and also, we don't know
which of those components are running

please, note it is not a 'moduled' kernel
is a static kernel and this means that
neither lsmod nor /proc/modules
provide the info that we are looking for

Kind Regards and Best Wishes,

Geraldo
-- 
site: http://extremedev.sf.net
msn: geraldo_boca_at_hotmail.com
skype: geraldo-netto
icq: 145-061-456
