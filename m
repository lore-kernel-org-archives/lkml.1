Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbYFLQT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbYFLQT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 12:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbYFLQTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 12:19:49 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43297 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753645AbYFLQTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 12:19:48 -0400
Date: Thu, 12 Jun 2008 11:19:43 -0500
From: Paul Jackson <pj@sgi.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, bwalle@suse.de, hannes@saeurebad.de, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, steiner@sgi.com
Subject: Re: Confusions with reserve_early, reserve_bootmem, e820, efi, ...
 on x86_64
Message-Id: <20080612111943.c140c4cb.pj@sgi.com>
In-Reply-To: <86802c440806120525v2da860bfyf05eb8ec6b9943d0@mail.gmail.com>
References: <20080612050609.88a8cf7f.pj@sgi.com>
	<86802c440806120525v2da860bfyf05eb8ec6b9943d0@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai wrote:
> then reserve_ebda_region() need to be fixed.

What do you have in mind here?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
