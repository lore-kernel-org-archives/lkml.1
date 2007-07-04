Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbXGDJHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbXGDJHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 05:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbXGDJHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 05:07:45 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:46133 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127AbXGDJHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 05:07:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=RLGet1BeT9J/Vlwl6GAgBwZeY0lr4Ger8fUt/QKFNdbspYyyUj4wG4fSwon0trMUsqPSN+oFJtz5moEc1tIHutUOwg1JqM0V8GhhAjQADobq+05BaOE97TCvPwbReVfTa9YxG+553YXGipHIZXPKFwdwU6ttKfqnBNIX3rAHM98=
Message-ID: <4104961b0707040207r7fd9054bvfd33830827102acf@mail.gmail.com>
Date: Wed, 4 Jul 2007 17:07:43 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [linux-kernel]Why there are so many struct rw_semaphore being defined?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I see struct rw_semaphore is defined in
include/linux/rwsem-spinlock.h,in the meanwhile, I also can find it in
include/asm-**/rwsem.h,for
example,include/asm-i386/rwsem.h,include/asm-x86_64/rwsem.h,why?which
one should be used?

Thanks
Jason Xiao
