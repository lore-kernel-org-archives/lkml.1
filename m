Return-Path: <linux-kernel-owner+w=401wt.eu-S933026AbYGQXMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026AbYGQXMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbYGQXMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:12:38 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:46031 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbYGQXMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:12:37 -0400
Date: Thu, 17 Jul 2008 16:12:35 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Andrew Vasquez <linux-driver@qlogic.com>,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
       Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [patch -mmotm 2/6] fix
	qla2xxx-use-memory_read_from_buffer.patch
Message-ID: <20080717231235.GR64690@n8027av35btxc1.qlogic.org>
References: <20080714025631.338886297@gmail.com> <20080714025742.370469321@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080714025742.370469321@gmail.com>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 17 Jul 2008 23:12:36.0783 (UTC) FILETIME=[99FA83F0:01C8E862]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, Akinobu Mita wrote:

> Now memory_read_from_buffer() belongs in string.h
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Andrew Vasquez <linux-driver@qlogic.com>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Cc: Seokmann Ju <seokmann.ju@qlogic.com>

If needed:

Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

BTW: is the memory_read_from_buffer() work for qla2xxx going in
through the mm tree submission path???
