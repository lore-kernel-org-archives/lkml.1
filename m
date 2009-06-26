Return-Path: <linux-kernel-owner+w=401wt.eu-S1760312AbZFZOH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760312AbZFZOH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZFZOHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:07:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56599 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752980AbZFZOHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:07:23 -0400
Date: Fri, 26 Jun 2009 15:08:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gallus <gall.cwpl@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel hard_start_xmit performance vs SOCK_RAW performance
Message-ID: <20090626150856.7b5fafb2@lxorguk.ukuu.org.uk>
In-Reply-To: <b08bcbf50906260704s11181158r27d88e2dd518b1e9@mail.gmail.com>
References: <b08bcbf50906260704s11181158r27d88e2dd518b1e9@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009 16:04:04 +0200
Gallus <gall.cwpl@gmail.com> wrote:

> Hi,
> what path would you choose to rapidly generate packets

Documentation/networking/pktgen.txt
