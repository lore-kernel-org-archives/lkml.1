Return-Path: <linux-kernel-owner+w=401wt.eu-S932467AbZKMXEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467AbZKMXEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932462AbZKMXEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:04:41 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:9236 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482AbZKMXEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:04:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=GqsLzXEDbbNb0/zt2FQw5wDAAuZ6C+MmEPdeg+GFI11RQ3+uOsMHX5/b9tbk98tX7v
         uJ2QjtwFdmWOwFb45dvq9ihrQ4jszLMIzmullt12koDtfoDp+FOu9mABiF57EjWQNN6/
         A8LJ9UIDPe0WAiDnD4NwODyY0e8yFq7Q2brD8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata: remove experimental tag on PATA drivers
Date: Fri, 13 Nov 2009 23:58:45 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
References: <4AFCC0D4.9020708@gmail.com> <200911132317.35088.bzolnier@gmail.com> <20091113224251.766c7910@lxorguk.ukuu.org.uk>
In-Reply-To: <20091113224251.766c7910@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911132358.45137.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 November 2009 23:42:51 Alan Cox wrote:
> 
> > 	http://article.gmane.org/gmane.linux.ide/43136
> > 
> > [ it has still unfixed problems.. ]
> 
> Which of course you haven't bothered to point out or explain.

I meant problems reported by Mikulas:

	http://thread.gmane.org/gmane.linux.ide/43069/focus=43136

Maybe they were fixed in your local tree but how would anyone know that given
that there haven't been any updates on the problem for the last two weeks..

-- 
Bartlomiej Zolnierkiewicz
