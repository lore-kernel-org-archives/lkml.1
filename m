Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZJ2LKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZJ2LKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 07:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZJ2LKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 07:10:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:54377 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbZJ2LKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 07:10:52 -0400
Message-ID: <4AE97860.30205@kernel.org>
Date: Thu, 29 Oct 2009 12:11:28 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: monstr@monstr.eu
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, mingo@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       rostedt@goodmis.org, hpa@zytor.com, cebbert@redhat.com,
       tony.luck@intel.com
Subject: Re: [PATCH 13/16] percpu: remove per_cpu__ prefix.
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-14-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0910141026370.26476@gentwo.org> <4AD6EA57.6020105@kernel.org> <4AD80CD6.7030204@monstr.eu> <4ADA845E.4080109@kernel.org> <4ADC6C76.3040908@monstr.eu>
In-Reply-To: <4ADC6C76.3040908@monstr.eu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

Michal Simek wrote:
> I compiled it there is no problem.
> I hope you will add these patches through linux-next which I test every day.

Yeap, I'm pushing it out soonish.  Sorry about the delay.  Have been
traveling.

Thanks.

-- 
tejun
