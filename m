Return-Path: <linux-kernel-owner+w=401wt.eu-S1757167AbYKETQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbYKETQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756991AbYKETPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:15:49 -0500
Received: from smarthost03.mail.zen.net.uk ([212.23.3.142]:58241 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754786AbYKETPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:15:48 -0500
Subject: Re: [PATCH v2] x86: Don't allow nr_irqs > NR_IRQS
From: Ben Hutchings <bhutchings@solarflare.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20081105191126.GA23548@localhost>
References: <1225819102.3074.15.camel@achroite>
	 <1225886687.3074.59.camel@achroite>  <20081105191126.GA23548@localhost>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Wed, 05 Nov 2008 19:15:31 +0000
Message-Id: <1225912531.3074.73.camel@achroite>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost03-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-05 at 22:11 +0300, Cyrill Gorcunov wrote:
[...]
> Ben I didn't manage to get a look over ACPI related changes
> (ie to find the reason why the kernel is able to reveal 5 IO-APICs
>  now
[...]

I was mistaken; that *isn't* a recent change.  A default RHEL 5 kernel
(based on 2.6.18) also finds 5 IOAPICs.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

