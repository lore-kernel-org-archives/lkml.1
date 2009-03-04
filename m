Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbZCDOcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbZCDOcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 09:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbZCDOcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 09:32:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34337 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751227AbZCDOcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 09:32:15 -0500
Date: Wed, 4 Mar 2009 14:32:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jiri Slaby <jirislaby@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Subject: Re: [PATCH 0/5] WM97xx updates
Message-ID: <20090304143212.GA1308@rakim.wolfsonmicro.main>
References: <20090303182402.GA29542@rakim.wolfsonmicro.main> <20090304091538.GD7394@dtor-d630.eng.vmware.com> <49AE492F.6020006@atmel.com> <20090304105358.GA32107@rakim.wolfsonmicro.main> <49AE65FF.2060309@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AE65FF.2060309@atmel.com>
X-Cookie: Hope is a waking dream.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 12:29:03PM +0100, Hans-Christian Egtvedt wrote:

> What is this patch based against? Linus tree, master branch?

This branch:

   git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git next

(though the noticable differences should be Makefile and Kconfig ones).
