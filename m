Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbYHDIbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbYHDIbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 04:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYHDIbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 04:31:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51193 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbYHDIba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 04:31:30 -0400
Subject: Re: [PATCH] embedded: fix vc_translate operator precedence
From: David Woodhouse <dwmw2@infradead.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Tim Bird <tim.bird@am.sony.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0808041028230.31424@vixen.sonytel.be>
References: <48937AAE.5070407@am.sony.com>
	 <Pine.LNX.4.64.0808041028230.31424@vixen.sonytel.be>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 09:31:25 +0100
Message-Id: <1217838685.3454.564.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 10:29 +0200, Geert Uytterhoeven wrote:
> The above paragraph is not part of the patch description and should
> not end up in the git history, so it should be below the first `---'
> and above the diffstat, i.e.

Since it reports successful testing, I figured I might as well keep it.

-- 
dwmw2

