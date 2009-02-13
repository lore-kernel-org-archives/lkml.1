Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZBMU7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZBMU7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZBMU7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:59:04 -0500
Received: from ozlabs.org ([203.10.76.45]:52102 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbZBMU7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:59:01 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: #tj-percpu has been rebased
Date: Sat, 14 Feb 2009 07:28:54 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, cpw@sgi.com
References: <49833350.1020809@kernel.org> <49939964.4070607@kernel.org> <49939B08.1050801@kernel.org>
In-Reply-To: <49939B08.1050801@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902140728.55954.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 February 2009 14:14:08 Tejun Heo wrote:
> Oops, those are the same ones.  I'll give a shot at cooking up
> something which can be dynamically sized before going forward with
> this one.

That's why I handed it to you! :)

Just remember we waited over 5 years for this to happen: the point of these
is that Christoph showed it's still useful.

(And I really like the idea of allocing congruent areas rather than remapping
 if someone can show that it's semi-reliable.  Good luck!)

Thanks!
Rusty. 
