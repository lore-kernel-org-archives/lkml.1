Return-Path: <linux-kernel-owner+w=401wt.eu-S1751933AbYJRUJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbYJRUJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 16:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbYJRUJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 16:09:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45335 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYJRUJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 16:09:47 -0400
Date: Sat, 18 Oct 2008 16:09:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Martin Michlmayr <tbm@cyrius.com>, Eric Sandeen <sandeen@sandeen.net>,
       Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org,
       debian-arm@lists.debian.org, xfs@oss.sgi.com
Subject: Re: XFS filesystem corruption on the arm(el) architecture
Message-ID: <20081018200939.GA3779@infradead.org>
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com> <20081017094615.GT4504@soziologie.ch> <20081018194851.GA2083@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081018194851.GA2083@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 10:48:53PM +0300, Kirill A. Shutemov wrote:
> Our team have experience with XFS on ARM OABI on NAS. It worked fine on
> 2.6.12, but got broken on 2.6.17.

So any chance to bisect it down to at least a kernel release where it
stopped working?

