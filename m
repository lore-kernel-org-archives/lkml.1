Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbYDJQ1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbYDJQ1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 12:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbYDJQ1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 12:27:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43942 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755227AbYDJQ1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 12:27:41 -0400
Date: Thu, 10 Apr 2008 11:27:36 -0500
From: Paul Jackson <pj@sgi.com>
To: "Bert Wesarg" <bert.wesarg@googlemail.com>
Cc: travis@sgi.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: add cpus_scnprintf function v3
Message-Id: <20080410112736.6c5ee654.pj@sgi.com>
In-Reply-To: <36ca99e90804100914n4b08cc9di9a6ab8b936f25644@mail.gmail.com>
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	<36ca99e90804091051k7c2cc97neba0ca1967625433@mail.gmail.com>
	<20080410071009.a5232b12.pj@sgi.com>
	<36ca99e90804100914n4b08cc9di9a6ab8b936f25644@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert wrote:
> My statement from above doesn't reflect my opinion. I'm still in
> flavor with the mask output. And from this discussion, I found a new
> point for the mask output: its bounded ;-)

Ok

> I just wanted to note, that these new list attributes would be the
> only way to 'change' the api, ie. introduce a new api and deprecate
> the old one, and not change the format of the present api.

Agreed

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
