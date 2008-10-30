Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYJ3Pjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYJ3Pjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbYJ3Pjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:39:40 -0400
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:52697 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbYJ3Pjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:39:40 -0400
Date: Thu, 30 Oct 2008 10:39:23 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub - fix get_object_page comment
In-Reply-To: <20081028190226.GE7357@localhost>
Message-ID: <Pine.LNX.4.64.0810301039080.20953@quilx.com>
References: <20081028190226.GE7357@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008, Cyrill Gorcunov wrote:

> Use 'slab page' instead of 'slab object'.

Acked-by: Christoph Lameter <cl@linux-foundation.org>
