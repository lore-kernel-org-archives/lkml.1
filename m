Return-Path: <linux-kernel-owner+w=401wt.eu-S1764517AbYEAVpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764517AbYEAVpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762031AbYEAVov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:44:51 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2976 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758697AbYEAVou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:44:50 -0400
Subject: Re: [PATCH 1/4] lib: add ascii hex helper functions
From: Joe Perches <joe@perches.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1209677706.24729.173.camel@brick>
References: <1209675067.24729.165.camel@brick>
	 <1209677314.4841.13.camel@localhost>  <1209677706.24729.173.camel@brick>
Content-Type: text/plain
Date: Thu, 01 May 2008 14:44:20 -0700
Message-Id: <1209678260.4841.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 14:35 -0700, Harvey Harrison wrote:
> The whole point is to start to centralize everybody's private copy of
> a hex_asc equivalent.

Which should be done via some function,
not via a char array right?

