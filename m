Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbZBUNMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbZBUNMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 08:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbZBUNML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 08:12:11 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:57828 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbZBUNMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 08:12:10 -0500
Date: Sat, 21 Feb 2009 13:12:09 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Paolo Ornati <ornati@fastwebnet.it>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@linux.ie>
Subject: Re: [BISECTED] [drm:i915_initialize] *ERROR* can not ioremap virtual address for ring buffer
Message-ID: <20090221131209.GB13134@silver.sucs.org>
References: <20090221110011.030cb16d@fastwebnet.it> <20090221121944.GA21090@silver.sucs.org> <20090221134933.368c2709@fastwebnet.it> <20090221135233.58fbae0b@fastwebnet.it> <20090221130521.GA13134@silver.sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090221130521.GA13134@silver.sucs.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 01:05:21PM +0000, Sitsofe Wheeler wrote:
> On Sat, Feb 21, 2009 at 01:52:33PM +0100, Paolo Ornati wrote:
> > 
> > Ah, you were taliking abount the "/proc/mtrr" change...
> > 
> > It's a "yes, it still happens" anyway:
> 
> Doh. Scratch that idea...

Hmm does the patch mentioned on
http://marc.info/?l=linux-kernel&m=123455194230641&w=2 help the DRM
error message (and if so does the mtrr weirdness still happen)?

-- 
Sitsofe | http://sucs.org/~sits/
