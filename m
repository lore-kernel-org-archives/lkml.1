Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbZAGIqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbZAGIqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 03:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbZAGIqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 03:46:00 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:58097 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZAGIp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 03:45:59 -0500
Date: Wed, 7 Jan 2009 09:47:39 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Patches applied to tip:x86/setup-lzma
Message-ID: <20090107084739.GA28865@uranus.ravnborg.org>
References: <200901042146.n04LkGTC005829@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <496468EE.9000802@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496468EE.9000802@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 12:33:50AM -0800, H. Peter Anvin wrote:
> I just applied these three patches to the tip:x86/setup-lzma tree to
> resolve the build issues in some configurations.  The third and largest
> patch is a slightly modified version of Alain's last patch, the other
> two addresses the Kconfig chain.  Please review.

Hi hpa.

Looks good from a quick scan.

	Sam
