Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbZDNO5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbZDNO5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188AbZDNO5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:57:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:49523 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbZDNO5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:57:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Nf+OpHcczU53Uc78o0M8WbFVGxN9MRH65XjSagq2dDdg3MW2bli4fWMY1uYBdElql7
         kwdKWnQGPZkrZfL9MQX8YrtC6U9r4n8ej0j3kC/r8vAp+pIWW305zuZxvfYQBOeiTU05
         cJutqoozxSX5lj27S1lRvYOSqM9kVmbFj70H8=
Date: Tue, 14 Apr 2009 18:57:32 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
Cc: alan-jenkins@tuffmail.co.uk, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fast testing
Message-ID: <20090414145732.GA12888@lenovo>
References: <2d05c4580904140255t25414b2bpe99b2a150dbe132a@mail.gmail.com> <9b2b86520904140636x1971b44g898c29e8b0904396@mail.gmail.com> <2d05c4580904140724n571dc877x66b50ae83dec075f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d05c4580904140724n571dc877x66b50ae83dec075f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Dragoslav Zaric - Tue, Apr 14, 2009 at 04:24:36PM +0200]
|
| The idea to compile targeted code like module is great,
| so when changed, re-insert resolves problem fast and you
| can see result immediately :)
| 
| thanks
| 

But don't be surprised if system gets down :)
Dragoslav (since I've been CC'ed on thread)
I believe the thread contains the mostly all testing
techniques I can imagine. qemu + thin distro image
is my preferred. And a real laptop as well.

        Cyrill
