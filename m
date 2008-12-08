Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbYLHVjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbYLHVjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 16:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbYLHVjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 16:39:05 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:38817 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbYLHVjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 16:39:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=rfjdlOsEmB7/OFzzHTBH3ojlJyDLlmS2Tesx1sZ1FliA7P1Gz2BBv/BQ3rKnmTCkf3
         DXh412ee+oy/kWV9SBTqpnEKLmWn9Y0kUcUnni8RlUX6raR3IEFHTRMnAhpoyHPnv4Tr
         fASc+2ZafNWt6sttNZg595I878XcY1L4JUWKg=
Message-ID: <524f69650812081339p41c7dfe7ud054158210e16845@mail.gmail.com>
Date: Mon, 8 Dec 2008 15:39:01 -0600
From: "Steve French" <smfrench@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: CIFS regression in 2.6.27.8
Cc: "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I just mounted a network drive (Windows Server) via CIFS under 2.6.27.8, and
> the sizes reported by "df" are completely incorrect:

The closest I had already installed was Ubuntu's most current kernel,
2.6.27-9-generic, which should be pretty close, and I did not see this
problem.  I would like to see a wireshark or tcpdump trace of this to
analyze it farther.  See
http://wiki.samba.org/index.php/Capture_Packets for details on this.
--
Thanks,

Steve
