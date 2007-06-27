Return-Path: <linux-kernel-owner+w=401wt.eu-S1763466AbXF0WWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763466AbXF0WWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760734AbXF0WWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:22:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757485AbXF0WWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:22:24 -0400
Message-ID: <4682D5FA.4050005@redhat.com>
Date: Wed, 27 Jun 2007 17:26:18 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: linux@horizon.com
CC: linux-kernel@vger.kernel.org, linux-laptop@vger.kernel.org, hpa@zytor.com
Subject: Re: 2.6.22-rcX Transmeta/APM regression
References: <20070627153114.17953.qmail@science.horizon.com>
In-Reply-To: <20070627153114.17953.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2007 11:31 AM, linux@horizon.com wrote:
> Hardware: Fujitsu Lifebook P-2040, TM5800 800 MHz processor
> 2.6.21: Closing the lid causes APM suspend.  Opening it resumes just fine.
> 2.6.22-rc5/-rc6: On resume, backlight comes on, but system is otherwise
> 	frozen.  Nothing happens until I hold the power button to force
> 	a power off.
> 

.config and contents of /proc/cpuinfo would be helpful...
