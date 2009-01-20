Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbZATPdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbZATPdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 10:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbZATPdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 10:33:09 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49508 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbZATPdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 10:33:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=mE+FJQDdqRj/FbOST0QHAQfudOSfmWO46g3jPE7TgijyW7ilg6ZVp0DaOU4IqwqeGt
         YFoPEuAbqZLXSgDSX45OGVfm9367hvCBHWqlYgghQQusFAzNbkElR/iS7kaeNyIQHu3p
         Yzvq6yIQT4uwLxnoT/g+3NgsdfJCPgVS7GI7A=
Date: Tue, 20 Jan 2009 16:26:12 +0100
From: Diego Calleja <diegocg@gmail.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Faulty seagate drives, are going to be blacklisted?
Message-ID: <20090120162612.7473aadf@diego-desktop>
In-Reply-To: <49753D09.8060503@shaw.ca>
References: <20090120002923.065f24ca@diego-desktop>
	<49753D09.8060503@shaw.ca>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, 19 Jan 2009 20:55:05 -0600, Robert Hancock <hancockr@shaw.ca> escribió:

> There are a few drives which are currently marked to disable NCQ and 
> warn the user that the firmware that should be upgraded:
> 
> ST31500341AS
> ST31000333AS
> ST3640623AS
> ST3640323AS
> ST3320813AS
> ST3320613AS
> 
> all for firmware versions SD15 through SD19.


Yes, I saw them, but apparently the NCQ bug is unrelated to this one.
