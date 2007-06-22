Return-Path: <linux-kernel-owner+w=401wt.eu-S1758339AbXFVUrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339AbXFVUrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 16:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbXFVUrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 16:47:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:39019 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbXFVUrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 16:47:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=flEaqU/kbgSPgXoBOBd0v7He33zjX0kJbx9dueAEgch4Nyn5VJ10aqtAwlBWzlyWAh4z2/YTVCkW4HltFx32qpj4XNjKSmCS1xH5xKO3Z1HGX9WFJqk/2tzNKPptFffgnP6EXbNMSS6u0Uon4/EXFTzbALjrdN3rWegYEIsdvHM=
Message-ID: <6101e8c40706221347p5f8b285eh95a8d6b6ba92fb3@mail.gmail.com>
Date: Fri, 22 Jun 2007 22:47:44 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, dgc@sgi.com
Subject: Re: [REGRESSION 2.6-git] possible circular locking dependency detected with XFS
In-Reply-To: <6101e8c40706221340k65f15957k39a04193cb6e7c01@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40706221340k65f15957k39a04193cb6e7c01@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

oh, the version is: 2.6.22-rc5-0864a4e
