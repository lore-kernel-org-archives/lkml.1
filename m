Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbXDILOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbXDILOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 07:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbXDILOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 07:14:04 -0400
Received: from smtp111.plus.mail.re2.yahoo.com ([206.190.53.36]:48943 "HELO
	smtp111.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753083AbXDILOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 07:14:02 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=QgNtWRmltRmCZxBUnVEOKJ4aGtTi8Dz7INhDXFMd3cpioCLAow2QSE1uZ+iOEE11J1DH6zoLRYavf+9g8Bxd4u2QdNZYYzlPE7AvfpSs4OzKZa9BsTi06WfGvRmyG1h0xamCQyctEQ1udolDKLPHa/3KGVl98lPiL+AC/tOM0EA=  ;
X-YMail-OSG: h5gzKMkVM1nVMSGIMAtUfD0gxt5.sHW6kRlEzQSpcEElYl43x6gM0xV66miGENKVSnOXLdUdow--
Date: Mon, 9 Apr 2007 13:13:55 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: 2.6.21-rc6-mm1
Message-ID: <20070409111355.GA4318@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070408143559.f5014629.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070408143559.f5014629.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, you can drop
> +kernel-doc-handle-spaces-in-array-size.patch
since 
> +kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
fixes the issue in a slightly better way.

-- 
Regards/Gruﬂ,
    Boris.
