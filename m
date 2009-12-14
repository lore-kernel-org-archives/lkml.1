Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbZLNS1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbZLNS1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 13:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932380AbZLNS1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 13:27:08 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:32994 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbZLNS1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 13:27:05 -0500
Message-ID: <4B268366.6090207@cs.helsinki.fi>
Date: Mon, 14 Dec 2009 20:26:46 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: upstream regression: slob hang
References: <20091210084949.GA18015@elte.hu>
In-Reply-To: <20091210084949.GA18015@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Ingo Molnar wrote:
> FYI, the attached config hangs in the SLOB code, on 32-bit x86 laptop 
> (dual core). No log available from that box.

Boots fine on my 32-bit x86 laptop.

			Pekka
