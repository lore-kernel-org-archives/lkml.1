Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbXEXVVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbXEXVVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbXEXVVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:21:17 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:9185 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbXEXVVR (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uVdnOaaLuxrSN86DNZcmGlyuvxhSOx7aKiQfiWb6ctWE/fh0TVhzC3dtUJY1sjc+dwGcV30gbfGoYqhQcjxhb7dhi+jxgs79jZeoUq+tRoNTmlVPORWsxsI3JBfqQikX8npmYNtgHjaL4geIdnbo+aE+GxEdwECYQLFEau7dGbs=
Message-ID: <6934efce0705241421i1cfc9c02h48f00bf433d2f76a@mail.gmail.com>
Date: Thu, 24 May 2007 14:21:04 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: richard.griffiths@windriver.com
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Cc: Linux-kernel@vger.kernel.org
In-Reply-To: <1180039939.27593.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179871779.24163.11.camel@localhost.localdomain>
	 <6934efce0705241322j7ad7c4fex621217e0749ddf3e@mail.gmail.com>
	 <1180039939.27593.8.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes you can, but I won't have access to a PXA270 for a few weeks. I
> assume you don't see the issue if you static link busybox?

I don't know.
