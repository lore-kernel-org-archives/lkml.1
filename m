Return-Path: <linux-kernel-owner+w=401wt.eu-S934582AbXGLOQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934582AbXGLOQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 10:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763821AbXGLOQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 10:16:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4625 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763703AbXGLOQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 10:16:19 -0400
Date: Thu, 12 Jul 2007 14:13:49 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: S3 state transition
Message-ID: <20070712141349.GB3881@ucw.cz>
References: <A3258B497F1C1441AD36A2E8B45FD628486D78@scsmsx412.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD628486D78@scsmsx412.amr.corp.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-07-11 16:15:37, Agarwal, Lomesh wrote:
> I am trying to understand how Linux handles S3 state transition.
> Specially I want to understand what it does anything for processes
> loaded at the time of transition. Any pointers to code/document will be
> helpful.

Do you mean suspend2ram? Search archives for freezer flamewar.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
