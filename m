Return-Path: <linux-kernel-owner+w=401wt.eu-S1761399AbZCXQsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761399AbZCXQsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763349AbZCXQs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:48:27 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48201 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760368AbZCXQsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:48:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=JNpg572KBIupOvFpIf0n5o1DwxJEqxIihBbFP81UajNeFR/kro3GucPn9RX6wwDJmO
         amTzhKEDA4gzxQf0r1QG+cEZU0X0gWvbnVJVp6l2QMIKeqpiCMigAmCfCmrKa5pmKt8D
         mcTca4McxfejZd/EFM0ryBjtTd7YEKHOFcm0M=
To: michal.simek@petalogix.com
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com, linux-serial@vger.kernel.org
Subject: Re: [PATCH 57/57] microblaze_v7: Uartlite for Microblaze
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
	<1e1dc8ccd5abc4e51272f52465c6b9e5f847f947.1237407249.git.monstr@monstr.eu>
	<14c123f2bae10a8b5fb76cd059ba105c212776ef.1237407249.git.monstr@monstr.eu>
	<4947b1131c14c1526b81493f461606018bd0f090.1237407249.git.monstr@monstr.eu>
	<46bc9a74719cb3c21dfdd558b93bec8c5b5675d8.1237407249.git.monstr@monstr.eu>
	<d3f49195b8f675db48d2eda4f09fddb51af6f946.1237407249.git.monstr@monstr.eu>
	<34c2f9e50610e147be556607e482b88fd674b887.1237407249.git.monstr@monstr.eu>
	<15f6f10873f7c6f4f3b06f9d4d5af3ee9714f873.1237407249.git.monstr@monstr.eu>
	<e5b88f50c39aa95431f5ecdb032c6676399ae198.1237407249.git.monstr@monstr.eu>
	<50253611a0770c1ae6a63702208cfb9f96cd1f1a.1237407249.git.monstr@monstr.eu>
	<28a81149bf51571cbc898a672efff4770fbc1efe.1237407249.git.monstr@monstr.eu>
	<55868bc389e07d10d00e92a1da65f31256a26f4c.1237407249.git.monstr@monstr.eu>
	<57d096a05c22f5b3dd1070e9ecd6e8e05b22e9b3.1237407249.git.monstr@monstr.eu>
	<49C9046A.6060708@petalogix.com>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Tue, 24 Mar 2009 17:47:53 +0100
In-Reply-To: <49C9046A.6060708@petalogix.com> (Michal Simek's message of "Tue\, 24 Mar 2009 17\:03\:54 +0100")
Message-ID: <87skl2kgue.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Michal" == Michal Simek <michal.simek@petalogix.com> writes:

 Michal> Hi all,
 Michal> Here is the small part of code which enable uartlite and serial of code
 Michal> driver for Microblaze cpu.

 Michal> Peter: I got ack from you in past. I believe that I still have it. Could
 Michal> I keep your ACK there?

Yes, Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
