Return-Path: <linux-kernel-owner+w=401wt.eu-S1756466AbYABJjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbYABJjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 04:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbYABJjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 04:39:25 -0500
Received: from smtp112.plus.mail.re1.yahoo.com ([69.147.102.75]:44625 "HELO
	smtp112.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753439AbYABJjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 04:39:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=4BGd9KnjDexniKQudBpu7PpG4xad3azc0J9hjjyr5UNxb4TTJZZYfB256EhFbbsc0sbuZbvjdh0IWGLnokAR8YVqAyXORMqwzV9aXUmVp7YBFFkI9ccZfbltX1NY5cuObrKUnGB5DaxJPBxsq7fucCtBwofaFRORIrAomUXRxR0=  ;
X-YMail-OSG: VffjilMVM1nvykupYhh0gt9pj7E9iDxWGB57e1pXxdRKIGE_oTjaaKMkRxDY_.TPUHqNhfXS1Q--
Date: Wed, 2 Jan 2008 10:36:46 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: ide-floppy redux p1
Message-ID: <20080102093646.GA16987@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080102092505.GA16665@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080102092505.GA16665@gollum.tnic>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 10:25:05AM +0100, Borislav Petkov wrote:

by the way, i messed up the numbering of the patches: their correct count is not
12 but 10 so you shouldn't be missing any even if it seems so at a first glance.

-- 
Regards/Gruﬂ,
    Boris.
