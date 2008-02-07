Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbYBGRWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbYBGRWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbYBGRWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:22:13 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:45004 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032AbYBGRWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:22:12 -0500
Date: Thu, 7 Feb 2008 18:21:17 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Carlos Aguiar <carlos.aguiar@indt.org.br>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/18] MMC: OMAP: Include missing from previous merging
Message-ID: <20080207182117.014cfb15@poseidon.drzeus.cx>
In-Reply-To: <479E27DA.8090804@indt.org.br>
References: <479E27DA.8090804@indt.org.br>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 15:07:06 -0400
Carlos Aguiar <carlos.aguiar@indt.org.br> wrote:

> From: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
> 
> This patch adds an include missing from previous merging
> mainline tree into linux-omap tree.
> 
> Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---

NAK. This header should not be needed in host drivers. It's a clear sign you're doing something bad.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
