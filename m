Return-Path: <linux-kernel-owner+w=401wt.eu-S932358AbYEAVcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbYEAVcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760631AbYEAVcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:32:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:58634 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYEAVcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:32:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=H9vTpUgP60ZdYcaOilUktkrplJNFTI9XCbn6c6KnYHSdpJc3BhYGpejHrrtD5/sQ8tBB1ghgA4x74wV7L92QdC0iIVu+PdWbn0TRMjBaE/TEcATbayMpYj5tmCUUYuzhI1DFrH4KN3P6gvf02vEzblALfIbhthprGRSpcw1LZfk=
Subject: Re: [PATCH 1/4] lib: add ascii hex helper functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080501141518.996edb65.akpm@linux-foundation.org>
References: <1209675067.24729.165.camel@brick>
	 <20080501141518.996edb65.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 14:32:18 -0700
Message-Id: <1209677538.24729.171.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 14:15 -0700, Andrew Morton wrote:
> On Thu, 01 May 2008 13:51:07 -0700
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > Everyone rolls their own version around the tree, centralize
> > in lib/hexdump.c
> > 
> > +extern const char hex_asc[];
> > +const char hexasc[16] = "0123456789abcdef";
> 
> If I were a compiler I'd get upset about that.
> 
> Honest, 24 hours really doesn't matter here.  Do it carefully, do
> it right.

...insert something here about improving quality ;-)


Harvey

