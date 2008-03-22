Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYCVShx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYCVShx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 14:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbYCVShr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 14:37:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36694 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbYCVShq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 14:37:46 -0400
Date: Sat, 22 Mar 2008 11:35:18 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Margit Schubert-While <margitsw@t-online.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: gcc change and kernel build
Message-ID: <20080322113518.6c949430@laptopd505.fenrus.org>
In-Reply-To: <5.1.0.14.2.20080322183805.02769f00@popmail.t-online.de>
References: <5.1.0.14.2.20080322183805.02769f00@popmail.t-online.de>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008 18:40:03 +0100
Margit Schubert-While <margitsw@t-online.de> wrote:

> Is this -
> http://marc.info/?l=gcc-bugs&m=120620193114127&w=2
> going to affect kernel builds?
> 

no; the kernel doesn't use nested functions
