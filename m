Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbZHCVWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbZHCVWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbZHCVWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:22:15 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:50154 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752400AbZHCVWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:22:14 -0400
From: Frans Pop <elendil@planet.nl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: MAINTAINERS: standardize James Bottomley's name
Date: Mon, 3 Aug 2009 23:22:12 +0200
User-Agent: KMail/1.9.9
Cc: James.Bottomley@hansenpartnership.com, joe@perches.com,
       linux-kernel@vger.kernel.org
References: <1249331570.5149.48.camel@Joe-Laptop.home> <1249332233.3943.211.camel@mulgrave.site> <1249332233.3943.211.camel@mulgrave.site> <4A77509A.3010401@zytor.com>
In-reply-To: <4A77509A.3010401@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908032322.14549.elendil@planet.nl>
X-OriginalArrivalTime: 03 Aug 2009 21:22:14.0939 (UTC) FILETIME=[78D9CEB0:01CA1480]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Now, obs- usually indicates an obsolete (deprecated
> backwards-compatibility) production, but the text states:
> 
> Note: The "period" (or "full stop") character (".") in obs-phrase is
> not a form that was allowed in earlier versions of this or any other
> standard.  Period (nor any other character from specials) was not
> allowed in phrase because it introduced a parsing difficulty
> distinguishing between phrases and portions of an addr-spec (see
> section 4.4).  It appears here because the period character is
> currently used in many messages in the display-name portion of
> addresses, especially for initials in names, and therefore must be
> interpreted properly.  In the future, period may appear in the
> regular syntax of phrase.
 
Interesting.

Does that mean that vger can stop refusing mails because they include an 
address that has an unquoted name with initials?
