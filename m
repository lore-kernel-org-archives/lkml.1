Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350Ab0BZVHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:07:53 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:48142 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab0BZVHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:07:52 -0500
Date: Fri, 26 Feb 2010 16:07:16 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: Ben Gardner <gardner.ben@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] OLPC: ALSA: fix cs5535audio's MIC GPIO to enable input
Message-ID: <20100226160716.1bd4e342@droptest.queued.net>
In-Reply-To: <808c8e9d1002260947k281782al889db51e20073648@mail.gmail.com>
References: <808c8e9d1002231455q379b26acq4b4a50188c5d73be@mail.gmail.com>
	<20100224184505.1d8d3380@droptest.queued.net>
	<808c8e9d1002260947k281782al889db51e20073648@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010 11:47:35 -0600
Ben Gardner <gardner.ben@gmail.com> wrote:

[...]
> 
> I'm working on a gpiolib patch that will combine gpio_direction_output
> and gpio_direction_input into one function.  That would enable the
> above driver to be 'obviously correct'.
> 

Cool.  I'm happy to help convert drivers if you want the help.
