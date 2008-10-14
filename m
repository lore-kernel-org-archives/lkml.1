Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbYJNM5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbYJNM5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 08:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbYJNM5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 08:57:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:17499 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbYJNM5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 08:57:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=xyD/+cN0UDk6Rzw9udxYYiV/FTEuCE0TEdq8YuV1OQz6IS4WqHvpChZMW0Wg7vq+Ec
         1BbSCDmIN2luF0rdq64AYFH9WbS1AX2As4W/SrFguTyritXaX0IPdHG9EwbJBhKO+FkN
         Wja4vfP5/gOlNjmmd5oCybCOzomH2zYRIBHb4=
Message-ID: <5a4c581d0810140557k37924493x1cad719ac69b205a@mail.gmail.com>
Date: Tue, 14 Oct 2008 14:57:35 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: heads-up: 2.6.27-git4 panics on boot and hangs hard in spin_bug
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will be posting details in a few hours when I'm back home,
 boot sequence of my Fedora 9 is about to complete with
 filesystems mounted, but the BUG doesn't hit the disk;
 x86 on a Dell Latitude D610.

2.6.27-git3 works fine.

--alessandro

 "Leave the city, leave the cold / Young people far too old"

   (Anna Ternheim, 'To Be Gone')
