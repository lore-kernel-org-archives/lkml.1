Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753162AbYLRLhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbYLRLhv (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 06:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbYLRLhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 06:37:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:4969 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbYLRLhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 06:37:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LxScq8qsf5+77bagDJv/vFenkeOvapchiwJNsQh3YvNc4j+cu+t9q/P1kib4ai42wr
         ug25iZR2iMVniHA8d0c3UzCk2UcVB8GhdZGl4bwow/51FydZsxaZ7MKBqY3Pidyn/bg2
         csAyoGH2qIcDGhq87rZFHsb+/XGlbfg38+0Yo=
Date: Thu, 18 Dec 2008 11:37:31 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Badalian Vyacheslav <slavon@bigtelecom.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: deadlocks if use htb
Message-ID: <20081218113731.GA9703@ff.dom.local>
References: <48F6FB3E.7060903@bigtelecom.ru> <20081016084027.GA17632@ff.dom.local> <48FEC302.5090707@bigtelecom.ru> <20081022070200.GB4178@ff.dom.local> <493FDCD4.5020108@bigtelecom.ru> <20081211084606.GA4129@ff.dom.local> <20081215111308.GA5853@ff.dom.local> <4949F127.6030105@bigtelecom.ru> <20081218081737.GA8416@ff.dom.local> <494A32B5.2020802@bigtelecom.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494A32B5.2020802@bigtelecom.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 02:23:33PM +0300, Badalian Vyacheslav wrote:
> Thanks for all Jarek!

The same to you for very valuable reporting and testing Vyacheslav!

Jarek P.
