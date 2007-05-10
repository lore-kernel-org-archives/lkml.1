Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbXEJCIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbXEJCIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 22:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbXEJCIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 22:08:38 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:58410
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbXEJCIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 22:08:37 -0400
From: Rob Landley <rob@landley.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] time locale in gen_initramfs_list.sh
Date: Wed, 9 May 2007 22:08:05 -0400
User-Agent: KMail/1.9.1
Cc: Florian Fainelli <florian.fainelli@int-evry.fr>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
References: <200705080755.31157.florian.fainelli@int-evry.fr> <20070509170926.27fad8bb.akpm@linux-foundation.org>
In-Reply-To: <20070509170926.27fad8bb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705092208.05796.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 May 2007 8:09 pm, Andrew Morton wrote:
> hm, --time-style sounds rather gnu-specific and perhaps we'd rather not
> add that requirement.  Or perhaps we already require gnu ls, dunno.

Running this sort of thing with busybox instead of the gnu tools is why I sent 
the gawk/awk patches earlier.  If a requirement for gnu ls has snuck in, it's 
been within the last few months.

Rob
