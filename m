Return-Path: <linux-kernel-owner+w=401wt.eu-S1031110AbXDYTfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031110AbXDYTfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031119AbXDYTfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:35:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031110AbXDYTf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:35:29 -0400
Date: Wed, 25 Apr 2007 15:35:11 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc7-mm1: Oops and Gnome desktop freezes
Message-ID: <20070425193511.GB3006@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Antonino A. Daplas" <adaplas@gmail.com>,
	Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <1177512596.4856.17.camel@daplas> <20070425121242.52698643.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425121242.52698643.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 12:12:42PM -0700, Andrew Morton wrote:
  > > EIP:    0060:[<c014c469>]    Tainted: G      D VLI
 > 
 > For some reason all oopses (and boy there are a lot of them) are being
 > described as tainted.

What's "D" though ?  grep -i taint broken-out/* doesn't show
-mm adding any new flags, and I don't see it present in mainline.

	Dave

-- 
http://www.codemonkey.org.uk
