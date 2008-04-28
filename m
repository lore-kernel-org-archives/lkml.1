Return-Path: <linux-kernel-owner+w=401wt.eu-S935146AbYD1PKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935146AbYD1PKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933796AbYD1PKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:10:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:53132 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934062AbYD1PK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:10:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ciZ/RnCyRMRpuh+prgrozEkDN2RZNM8bGmWD47HxkiYH93IXRUUsRG27wbHL2FCZEeQ7/08qKoV65LNZmdgBMNimNPkAWIQtP+yAYFoKXVgNrl1WVydISCN1+TqKEP435U8k4hKm1k29NY3QSrG7eklTHaxKAmpFqnTfdkpt+y4=
Subject: Re: [PATCH] x86: !x & y typo in mtrr code
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080428112714.GB18074@elte.hu>
References: <1209268817.14173.43.camel@brick>
	 <20080428112714.GB18074@elte.hu>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 08:10:39 -0700
Message-Id: <1209395439.14173.82.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-28 at 13:27 +0200, Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > As written, this can never be true.
> 
> thanks Harvey, applied. Found via Sparse?
> 

Yeah.

Harvey

