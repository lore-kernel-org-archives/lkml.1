Return-Path: <linux-kernel-owner+w=401wt.eu-S1762207AbZAOQyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762207AbZAOQyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 11:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbZAOQym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 11:54:42 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:46389 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750825AbZAOQyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 11:54:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KCTYYGQG4o99WR2EaCeZPC5Lztg8lvM356MtDm6n5evhBYIqZGxFaiGld2eV7eYdOU2WpMfg8VpZwI5knQtXEK5ombVRMJwCVdNf3kYy6GxhSeGIzlNn+B/qlBxltAiOEvNgSHebUdcBM9MC1uVqYX0AwFzAoIeTY2pF0Td8uV8=  ;
X-YMail-OSG: megg2CQVM1kI83YMRzH7bkZywXEn_0wuJqMi9D0JNvc5j7l75BX3BO.jk1TL_jZ3vr5bnkBGpmMEIpw06vUilehO52kSsxViyv8FXq0aNJEcix9K1xEloCThR4MNk5EVzWZPa3O7NBnzAXUyxAuV2PMQ
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.29-rc] regulator: add get_status()
Date: Thu, 15 Jan 2009 08:54:38 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
References: <200811091531.46003.david-b@pacbell.net> <200901150735.29883.david-b@pacbell.net> <20090115160517.GA12768@sirena.org.uk>
In-Reply-To: <20090115160517.GA12768@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200901150854.38686.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009, Mark Brown wrote:
> No, real kerneldoc - this was added recently, check current mainline
> (eg, commit c8e7e4640facbe99d10a6e262523b25be129b9b9).  I'm not saying
> it's great but it's there.

Ah, I see.  Makes sense now -- I just didn't think this routine
should have been the first!  ;)

Will do.  Gotta update some trees first.

- Dave



