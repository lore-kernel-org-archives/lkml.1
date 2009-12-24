Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbZLXKNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbZLXKNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 05:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbZLXKNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 05:13:16 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:28125 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbZLXKNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 05:13:15 -0500
Subject: Re: [PATCH] regulator/lp3971: Storage class should be before const
 qualifier
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1261573997-9126-1-git-send-email-tklauser@distanz.ch>
References: <1261573997-9126-1-git-send-email-tklauser@distanz.ch>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Dec 2009 10:13:10 +0000
Message-ID: <1261649590.3554.2.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-23 at 14:13 +0100, Tobias Klauser wrote:
> The C99 specification states in section 6.11.5:
> 
> The placement of a storage-class specifier other than at the beginning
> of the declaration specifiers in a declaration is an obsolescent
> feature.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  drivers/regulator/lp3971.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 

Applied.

Thanks

Liam

