Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbYEYO1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbYEYO1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 10:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYEYO11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 10:27:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59248 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYEYO11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 10:27:27 -0400
Subject: Re: [PATCHv2 22/28] cxusb: treat firmware data as const
From: David Woodhouse <dwmw2@infradead.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org,
       Patrick Boettcher <patrick.boettcher@desy.de>,
       Chris Pascoe <c.pascoe@itee.uq.edu.au>
In-Reply-To: <48397436.8040102@linuxtv.org>
References: <1211708969@pmac.infradead.org>
	 <E1K0DOK-0007EC-6q@shinybook.infradead.org>  <48397436.8040102@linuxtv.org>
Content-Type: text/plain
Date: Sun, 25 May 2008 15:27:19 +0100
Message-Id: <1211725639.31212.110.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-25 at 10:14 -0400, Michael Krufky wrote:
> The unmodified firmware was being uploaded to the device, instead of
> the patched firmware :-(

Heh. Stupid dwmw2. Thanks.

-- 
dwmw2

