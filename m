Return-Path: <linux-kernel-owner+w=401wt.eu-S965460AbXAWVc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965460AbXAWVc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 16:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965465AbXAWVcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 16:32:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:50428 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965460AbXAWVcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 16:32:25 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Lionel Landwerlin <landwer@free.fr>
Subject: Re: 2.6.19.2 sky2/acpi crashes
Date: Tue, 23 Jan 2007 16:30:53 -0500
User-Agent: KMail/1.9.5
Cc: Luming Yu <luming.yu@gmail.com>, linux-kernel@vger.kernel.org
References: <1169542768.5537.11.camel@cocoduo> <3877989d0701230122r426eb5b0h446c897780923d7a@mail.gmail.com> <1169555238.5747.3.camel@cocoduo>
In-Reply-To: <1169555238.5747.3.camel@cocoduo>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701231630.55096.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 January 2007 07:27, Lionel Landwerlin wrote:
> Le mardi 23 janvier 2007 à 17:22 +0800, Luming Yu a écrit :
> > Please try to remove processor module.
> 
> Ok, that's done. Same problem.

any difference with "idle=poll"?
if yes, how about "idle=halt"?
