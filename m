Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0CLAPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 19:15:48 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:60531 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab0CLAPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 19:15:47 -0500
Subject: Re: vfs-scalability: odd null pointer issue in link_path_walk
From: john stultz <johnstul@us.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
In-Reply-To: <1268352805.3475.60.camel@localhost.localdomain>
References: <1268352805.3475.60.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 16:15:32 -0800
Message-ID: <1268352932.3475.61.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 16:13 -0800, john stultz wrote:
> Hey Nick,
> 	So yesterday I came across an odd null pointer oops in link_path_walk:

Sorry. That's not as clear as I wanted it to be, it was a *boot-time*
null pointer oops. 

thanks
-john




