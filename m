Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZGHLXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZGHLXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbZGHLXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:23:23 -0400
Received: from relay.atmel.no ([80.232.32.139]:55353 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbZGHLXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:23:22 -0400
Date: Wed, 8 Jul 2009 13:23:08 +0200
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel@avr32linux.org
Subject: Re: [BUG 2.6.30] Bad page map in process
Message-ID: <20090708132308.12b25ac9@hcegtvedt.norway.atmel.com>
In-Reply-To: <Pine.LNX.4.64.0907081250110.15633@axis700.grange>
References: <Pine.LNX.4.64.0907081250110.15633@axis700.grange>
Organization: Atmel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jul 2009 13:07:31 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

Hi Guennadi,

> with a 2.6.30 kernel 
>

Could you give a short description of the rest of your setup as well?

libc library and version number? Latest known to be good is uClibc
v0.9.30.1.

binutils version? Latest known to be good is binutils version
2.18.atmel.1.0.1.buildroot.1.

gcc version? Latest known to be good is gcc version
4.2.2-atmel.1.1.3.buildroot.1.

<snipp link to patch and BUG output>

-- 
Best regards,
Hans-Christian Egtvedt
