Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbZKJRgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbZKJRgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbZKJRgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:36:04 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:47642 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbZKJRgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:36:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Pbvd6txIqln0ozqANb+rb1gtIhOltyxg25aJEK+ygu0iuqCGSJCpaL/cQzcixPibY7
         YLG9izQK5uFLnNsECWZd+PrflxnrMNHiTnssmC+oM+a0NHewVJ+WMMcSz/pmYhFi36RW
         zKHZm9ARKmnMyiAvRvFnZ/J/Dwy2OmGK3C+uI=
MIME-Version: 1.0
In-Reply-To: <20091110171734.085189722@fluff.org.uk>
References: <20091110171734.085189722@fluff.org.uk>
Date: Tue, 10 Nov 2009 15:36:05 -0200
Message-ID: <a4c8a6d00911100936q608b15c5wae8516ef05890e9c@mail.gmail.com>
Subject: Re: SM501: Fix missing uses of resource_size()
From: Thiago Farina <tfransosi@gmail.com>
To: Ben Dooks <ben@simtec.co.uk>
Cc: akpm@linux-foundation.org, krzysztof.h1@wp.pl, lethal@linux-sh.org,
       dilinger@debian.org, linux-kernel@vger.kernel.org,
       Simtec Linux Team <linux@simtec.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you attach the patch as a plain text in the body of email and
[PATCH] at the subject line?
