Return-Path: <linux-kernel-owner+w=401wt.eu-S1752305AbZEQGSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbZEQGSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 02:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZEQGSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 02:18:01 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:54869 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbZEQGSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 02:18:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iKflDB8HzGKvFz585PpfQ4W8fG/vWnYUBqnuX3/B4AmbNq1LzUCaO3ZjxGTY0DoOUI
         gVQOkObwGl6N9z45Qg7wKI57U90pnkCFAUmfyUPWMgBafcMshJQZpy2sbJrQogcTE7zo
         nDUuB0hUjx4FSTk9gJNa5wyQVXHo3sRPcDk9k=
MIME-Version: 1.0
In-Reply-To: <20090517045800.GA32723@localhost>
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com>
	 <2c0942db0905151102y4f144437xa02632effccda72c@mail.gmail.com>
	 <alpine.DEB.1.10.0905151533070.13433@qirst.com>
	 <2c0942db0905160903i5517d3d6l50fc7457a2629694@mail.gmail.com>
	 <4A0EFA08.4060106@redhat.com> <20090517011906.GA6375@localhost>
	 <93655eb70905161827x34a432ebn4910ee86d9bae30@mail.gmail.com>
	 <20090517020829.GB6809@localhost>
	 <93655eb70905162130k13ebd627o5eba2582508a1c07@mail.gmail.com>
	 <20090517045800.GA32723@localhost>
Date: Sun, 17 May 2009 11:48:01 +0530
Message-ID: <93655eb70905162318oeccafa9p76b5594f9625aefc@mail.gmail.com>
Subject: Re: unresponsiveness on linux desktop during file copy
From: Satish Eerpini <eerpini@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rik van Riel <riel@redhat.com>, Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The numbers listed in your email? No the most relevant numbers are
> memory and disk ones.

the numbers I earlier mentioned were the output of : "sar"
for the number of mapped pages stays almost constant on my lappy too :
Mapped:            70840 kB
Mapped:            70860 kB
Mapped:            70736 kB
Mapped:            70860 kB
Mapped:            70736 kB
Mapped:            70860 kB
Mapped:            70860 kB
Mapped:            70736 kB
Mapped:            70736 kB
Mapped:            70736 kB
Mapped:            70860 kB
Mapped:            70736 kB
Mapped:            70736 kB
Mapped:            70860 kB
Mapped:            70860 kB
Mapped:            70736 kB
Mapped:            70736 kB
Mapped:            70860 kB
Mapped:            70860 kB
Mapped:            70736 kB
Mapped:            70736 kB
Mapped:            70736 kB
Mapped:            70736 kB
Mapped:            70736 kB
Mapped:            70860 kB
Mapped:            70860 kB
Mapped:            70736 kB
Mapped:            70860 kB
Mapped:            70736 kB
Mapped:            70724 kB
Mapped:            70860 kB
Mapped:            70860 kB
Mapped:            70736 kB
Mapped:            70736 kB

Satish
-- 
http://satish.playdrupal.com
