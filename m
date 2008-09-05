Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYIEOA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYIEOA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbYIEOAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:00:49 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:34621 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbYIEOAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:00:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=mGWCFYNpml4xdS/j5PdLtIrNdksr7YDHe9RdW0FNPKkUMFQMMyZSmYkKWwDg0pu5D7
         eczCc97+vqAHqrRFMnHl1vqaCZsMZhANQS5mX9HXLQBv8CFJJCOMAsMw/OaW6I+UWcxX
         ZGGbN+CXfIBKsjJX/gjQTlI/yRChglEgcq0E0=
Message-ID: <386072610809050700l192b7c29me1920da8dc37054@mail.gmail.com>
Date: Fri, 5 Sep 2008 22:00:47 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Bryan Wu" <cooloney@kernel.org>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 0/9] ASoC Blackfin supporting (v2)
In-Reply-To: <20080905123701.GE12383@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220610102-7716-1-git-send-email-cooloney@kernel.org>
	 <20080905123701.GE12383@sirena.org.uk>
X-Google-Sender-Auth: cc1ddbc8eaa5818d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2008 at 8:37 PM, Mark Brown <broonie@sirena.org.uk> wrote:
> On Fri, Sep 05, 2008 at 06:21:33PM +0800, Bryan Wu wrote:
>
>> With Cliff's effort, we update this patch series quickly according to
>> your review.
>
> Thanks.  Please, when sending updates to this patch series could you
> send incremental patches as I asked?  There is a lot of code here, most
> of which has already been acked and is not changing so showing only the
> changes that have been made will greatly simplify the review process.
>

Thanks, I will follow this procedure as your mentioned. I just want to
make it easier for
your git-am operation, -:)))

-Bryan
