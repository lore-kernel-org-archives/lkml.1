Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbYG1PU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbYG1PU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYG1PUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:20:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:30020 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbYG1PUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:20:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LnVSIlgcaFXV5koahIS2sxFgw7BaUvGRsgZ4x6u1Fof7GwAO/E1pPqCH7r4TZl1YiC
         dT1Iw0IvIdU3WJK30xVn7zeO4oPJfSDZwaoceNzDLqK9fzsn453mH2Qu0c2jiD924sLj
         D0AISfaL4zzez3UuG6VGmmh2EC0k3DsbuOjdQ=
Message-ID: <9e4733910807280820v118b728fu1c0a8b8eb4c4fdaa@mail.gmail.com>
Date: Mon, 28 Jul 2008 11:20:49 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
In-Reply-To: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some stats using the new mailmap file:

Patches, number of developers
1, 1591
2, 484
3, 254
4, 152
5, 118
more, 1242

Top twenty developers:

Linus Torvalds (4350):
Andrew Morton (1789):
Adrian Bunk (1774):
Al Viro (1735):
Ingo Molnar (1393):
Ralf Baechle (1367):
Jeff Garzik (1291):
Takashi Iwai (1196):
Tejun Heo (1092):
Bartlomiej Zolnierkiewicz (1071):
David S. Miller (1069):
Patrick McHardy (1031):
Stephen Hemminger (1017):
Russell King (985):
Andi Kleen (973):
Thomas Gleixner (953):
Alan Cox (822):
Paul Mundt (813):
Dave Miller (787):

Make your own list:
   git shortlog | grep -v ^[[:space:]] | grep -v ^$ | sort -t "(" -g -k 2 -r


-- 
Jon Smirl
jonsmirl@gmail.com
