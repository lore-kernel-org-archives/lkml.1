Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbZB0NFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbZB0NFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 08:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbZB0NFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 08:05:08 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:48041 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbZB0NFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 08:05:07 -0500
Date: Fri, 27 Feb 2009 13:04:40 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, airlied@linux.ie, eric@anholt.net,
       keithp@keithp.com, dri-devel@lists.sourceforge.net,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: i915 X lockup
Message-ID: <20090227130440.GA24633@silver.sucs.org>
References: <49A7B253.906@gmail.com> <20090227023231.76e7c65f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227023231.76e7c65f.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 02:32:31AM -0800, Andrew Morton wrote:
> On Fri, 27 Feb 2009 10:28:51 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:
> 
> > everytime I run X, it gets stuck. Currently running on mmotm 
> > 2009-02-26-16-58, but I think this is wider problem. I had i915 disabled 
> > for a long time (until I noticed today).

Which version of X are you using? Does it support kernel modesetting? If
not, did you disable kernel modesetting in the KConfig file for i915?

-- 
Sitsofe | http://sucs.org/~sits/
