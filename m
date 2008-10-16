Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbYJPTnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbYJPTnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbYJPTnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:43:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753142AbYJPTnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:43:13 -0400
Message-ID: <48F7993E.8000306@linux-foundation.org>
Date: Thu, 16 Oct 2008 14:42:54 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Brice Goglin <Brice.Goglin@inria.fr>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nathalie Furmento <nathalie.furmento@labri.fr>
Subject: Re: [PATCH 5/5] mm: move_pages: no need to set pp->page to ZERO_PAGE(0)
 by default
References: <48F3AD47.1050301@inria.fr> <48F3AE45.90104@inria.fr>
In-Reply-To: <48F3AE45.90104@inria.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Christoph Lameter <cl@linux-foundation.org>
