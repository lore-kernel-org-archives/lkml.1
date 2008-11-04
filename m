Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbYKDXBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbYKDXBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYKDXBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:01:05 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:9456 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbYKDXBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:01:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Yb+pWKBR3Fs3V2Mc6k1NQ0TvroIeKkhNKE5ePrNPwdaBClieiNwWy5jZH/YLRNXpnP
         fY89cU3f5QFmo0sC9ejSY6E0KZE7OBH9JaTFh6BHUIqqd47/TZjX2KZTO8kepUN2rX0d
         YkvSl7tbRnIhd7OByMLdpd/XxOzGsQtI1obIk=
Message-ID: <e9c3a7c20811041501r7800233dm5ba3877c883f0cbd@mail.gmail.com>
Date: Tue, 4 Nov 2008 16:01:03 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: dmaengine: struct device - replace bus_id with dev_name(), dev_set_name()
Cc: "Maciej Sosnowski" <maciej.sosnowski@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>
In-Reply-To: <1225326543.5970.25.camel@nga.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225326543.5970.25.camel@nga.site>
X-Google-Sender-Auth: 75e398ca59ab747e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 5:29 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> We need to get rid of all occurrences of bus_id in the entire tree
> to be able to enable the new interface. Please apply this patch,
> and possibly convert any remaining remaining occurrences of bus_id.
>

Applied to async_tx.git#next.
