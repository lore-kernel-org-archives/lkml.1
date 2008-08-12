Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbYHLBES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbYHLBES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 21:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750722AbYHLBEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 21:04:05 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:19880 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYHLBED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 21:04:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sU/H28JQKzME8znU35w6vQ57ZYC97+2SFKlSfu6F9Lc9BhjPegdWZ5TZGJAYWjwJo0
         Dl6H/tRfPHkBfiZMYyBg2mL0CxGqykXMeTijQwEUyw6J8N1a3jxdHjgk78qFauAx5eyE
         +lviTI9DQYuJ4e/zdcKZztPotXeZZPPPf8VDg=
Message-ID: <43e72e890808111804j6ecd66c9r9907523d7f7594ed@mail.gmail.com>
Date: Mon, 11 Aug 2008 18:04:01 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: CRDA and uevent
Cc: "linux kernel" <linux-kernel@vger.kernel.org>,
       "Marcel Holtmann" <marcel@holtmann.org>
In-Reply-To: <43e72e890808051812y1f6b18ecpac089e45d4c18b84@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43e72e890808051812y1f6b18ecpac089e45d4c18b84@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2008 at 6:12 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:

> Marcel I know you also mentioned about using device platform for this?
> Is this correct or did I misunderstand? Can you elaborate a bit?

OK I got this to work, will send patches soon.

  Luis
