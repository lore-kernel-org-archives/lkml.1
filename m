Return-Path: <linux-kernel-owner+w=401wt.eu-S1161012AbXBGNfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161012AbXBGNfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 08:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161300AbXBGNfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 08:35:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:39047 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161295AbXBGNfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 08:35:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pP8u5Hip9MpKtUqjfsLxqk8d3r5bBPCZZe8+ryu6iK8q/1L9NpCEq5vpkwuKJBeUCWs4k2jLd+h1VNbGVdsj8HEE1VQIrUka7xi9uXVR1860tXJ4PkmcOD3dtV3+dzkfkUp/fCsPun2U8OTsqXFH9wveu96memPCnBdv2hWNrCM=
Message-ID: <d0383f90702070535q3a26ff41t85daef531f13256e@mail.gmail.com>
Date: Wed, 7 Feb 2007 15:35:17 +0200
From: "Ian Brown" <ianbrn@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: doors in linux (a bit OT)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
 I saw that there is a project in sf.net called Linux Doors.
 (nikitadanilov)

see http://sourceforge.net/projects/ldoor/
It is from 2001.

The doors in a lightweight and fast IPC mechanism.
It seems to me better (and maybe simpler?) than Unix local sockets or others
podix IPC  (maybe I am wrong) in terms of overhead.

My question is : It seems that the
implementation of doors is not very complex in Open Solaris
Is there a reason that the doors mechanism was not
adopted by the linux kernel?

Regards,
Ian
