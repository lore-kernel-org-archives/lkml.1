Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbYAGMCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbYAGMCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 07:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbYAGMC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 07:02:27 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:37248 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbYAGMC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 07:02:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=khPoe8NwjnkAgPhaTFOv3GXvFyS/9XSwfglL/8bqjRKKSnvxCgJ6Ueg/CaDyxXdqTPqPx9YQSmOuOHCj4SU/K0fg0Mrf4PwXEQLYFqzZV/T2lm4NYPZKYlfYs4GSEU8hyIJSmqWBSdxQYlMoSN7abLdW4t8weDTxxxVitg317NU=
Message-ID: <b4292e150801070402m14221e9fh6b965a5932f78a4c@mail.gmail.com>
Date: Mon, 7 Jan 2008 09:02:23 -0300
From: "Adolfo R. Brandes" <arbrandes@gmail.com>
To: "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>
Subject: Re: forcedeth: MAC-address reversed on resume from suspend
Cc: "Adrian Bunk" <bunk@kernel.org>, "Andreas Mohr" <andi@lisas.de>,
       "Richard Jonsson" <richie@coderworld.net>, linux-kernel@vger.kernel.org,
       "Ayaz Abdulla" <aabdulla@nvidia.com>, jgarzik@pobox.com,
       netdev@vger.kernel.org
In-Reply-To: <20080107014638.GA4170@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <477BFC71.7090002@coderworld.net>
	 <20080102214843.GA19224@rhlx01.hs-esslingen.de>
	 <20080102234209.GA10831@does.not.exist>
	 <20080104034357.GA2113@atjola.homenet>
	 <b4292e150801061349v3b54ffc0vfed75dbcb83daf9b@mail.gmail.com>
	 <20080107014638.GA4170@atjola.homenet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Jan 6, 2008 10:46 PM, Björn Steinbrink <B.Steinbrink@gmx.de> wrote:
> Any chance that you applied the patch on your modified sources and didn't get it right?

  It is perfectly possible that I messed something up, although I
double checked what I was doing on the MCP51.  However, on that board
(an Asus M2NPV-VM) I'm running the 2.6.22-based Ubuntu Gutsy default
kernel with a recompiled forcedeth, as opposed to a vanilla 2.6.24-rc6
on the CK804, where your patch worked.  It may be that the different
kernel is throwing the patch off somehow.

  Later on today I'm going to try the MCP51 with the same build of
2.6.24-rc6 (built on a .config from the Ubuntu Hardy development
kernel) I'm running on the CK804, and post results.

Adolfo
