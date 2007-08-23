Return-Path: <linux-kernel-owner+w=401wt.eu-S1762416AbXHWMBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762416AbXHWMBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758241AbXHWMAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:00:51 -0400
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:39463 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815AbXHWMAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:00:50 -0400
Date: Thu, 23 Aug 2007 14:00:25 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: wharms@bfs.de
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: Ideas on column length in kernel "problem"?
Message-ID: <20070823140025.1c49d9e8@localhost>
In-Reply-To: <46CD7600.6020608@bfs.de>
References: <20070823035442.6FD0DDA81F@mailserver7.hushmail.com>
	<20070823093629.032f82aa@localhost>
	<46CD7600.6020608@bfs.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 13:56:48 +0200
walter harms <wharms@bfs.de> wrote:

> xclip converts tabs to space if i remember correctly

no, it doesn't


paolo@tux ~ $ echo -e "\tHello" | xclip

(middle mouse button)

	Hello

:)

-- 
	Paolo Ornati
	Linux 2.6.23-rc3-g2a677896-dirty on x86_64
