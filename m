Return-Path: <linux-kernel-owner+w=401wt.eu-S1760685AbZAGTw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685AbZAGTw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbZAGTwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:52:50 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:34399 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZAGTwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:52:49 -0500
Date: Wed, 7 Jan 2009 20:54:29 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, davej@redhat.com,
       fweisbec@gmail.com
Subject: Re: [PATCH] bootchart: improve output based on Dave Jones' feedback
Message-ID: <20090107195429.GC4647@uranus.ravnborg.org>
References: <20090104071638.64be922a@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104071638.64be922a@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 07:16:38AM -0800, Arjan van de Ven wrote:
> 
> Subject: bootchart: improve output based on Dave Jones' feedback
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> Dave Jones, in his blog, had some feedback about the bootchart script:
> Primarily his complaint was that shorter delays weren't visualized.
> 
> The reason for that was that too small delays will have their labels
> mixed up in the graph in an unreadable mess.
> 
> This patch has a fix for this; for one, it makes the output wider,
> so more will fit.
> The second part is that smaller delays are now shown with a
> much smaller font for the label; while this isn't per se 
> readable at a 1:1 zoom, at least you can zoom in with most SVG
> viewing applications and see what it is you are looking at.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Applied to kbuild-fixes.git

	Sam
