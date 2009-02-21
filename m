Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbZBUMT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbZBUMT4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 07:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZBUMTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 07:19:47 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:44454 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbZBUMTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 07:19:47 -0500
Date: Sat, 21 Feb 2009 12:19:44 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Paolo Ornati <ornati@fastwebnet.it>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@linux.ie>
Subject: Re: [BISECTED] [drm:i915_initialize] *ERROR* can not ioremap virtual address for ring buffer
Message-ID: <20090221121944.GA21090@silver.sucs.org>
References: <20090221110011.030cb16d@fastwebnet.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090221110011.030cb16d@fastwebnet.it>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 11:00:11AM +0100, Paolo Ornati wrote:
> 
> Booting current -git with that commit reverted (good) and not reverted
> (bad), with "fastboot initcall_debug" I've noticed mtrr change:

Does this happen when you enable the mtrr cleaner? -
http://marc.info/?l=linux-kernel&m=123501581629566&w=2

-- 
Sitsofe | http://sucs.org/~sits/
